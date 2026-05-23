package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;

public class ServletTestSupport {

    public static void initServlet(HttpServlet servlet, File webRoot) throws Exception {
        DataFileUtil.initDataDir(webRoot.getAbsolutePath());

        ServletContext servletContext = servletContext(webRoot);

        ServletConfig servletConfig = proxy(ServletConfig.class, (proxy, method, args) -> {
            if ("getServletContext".equals(method.getName())) {
                return servletContext;
            }
            if ("getServletName".equals(method.getName())) {
                return servlet.getClass().getSimpleName();
            }
            return defaultValue(method.getReturnType());
        });

        servlet.init(servletConfig);
    }

    public static ServletContext servletContext(File webRoot) {
        return proxy(ServletContext.class, (proxy, method, args) -> {
            if ("getRealPath".equals(method.getName())) {
                return webRoot.getAbsolutePath();
            }
            return defaultValue(method.getReturnType());
        });
    }

    public static ServletContextEvent contextEvent(File webRoot) {
        return new ServletContextEvent(servletContext(webRoot));
    }

    public static HttpServletRequest request(Map<String, String> params, HttpSession session) {
        return proxy(HttpServletRequest.class, (proxy, method, args) -> {
            String name = method.getName();
            if ("getParameter".equals(name)) {
                return params.get((String) args[0]);
            }
            if ("getContextPath".equals(name)) {
                return "/ta";
            }
            if ("getSession".equals(name)) {
                if (args == null || args.length == 0) {
                    return session;
                }
                return Boolean.TRUE.equals(args[0]) ? session : session;
            }
            if ("setCharacterEncoding".equals(name)) {
                return null;
            }
            return defaultValue(method.getReturnType());
        });
    }

    public static HttpServletResponse response(StringBuilder redirectLocation) {
        return proxy(HttpServletResponse.class, (proxy, method, args) -> {
            if ("sendRedirect".equals(method.getName())) {
                redirectLocation.setLength(0);
                redirectLocation.append((String) args[0]);
                return null;
            }
            return defaultValue(method.getReturnType());
        });
    }

    public static HttpSession session(Map<String, Object> attributes) {
        return proxy(HttpSession.class, (proxy, method, args) -> {
            String name = method.getName();
            if ("getAttribute".equals(name)) {
                return attributes.get((String) args[0]);
            }
            if ("setAttribute".equals(name)) {
                attributes.put((String) args[0], args[1]);
                return null;
            }
            if ("invalidate".equals(name)) {
                attributes.clear();
                attributes.put("__invalidated", true);
                return null;
            }
            return defaultValue(method.getReturnType());
        });
    }

    public static Map<String, String> params(String... keyValues) {
        Map<String, String> params = new HashMap<>();
        for (int i = 0; i < keyValues.length; i += 2) {
            params.put(keyValues[i], keyValues[i + 1]);
        }
        return params;
    }

    @SuppressWarnings("unchecked")
    private static <T> T proxy(Class<T> type, InvocationHandler handler) {
        return (T) Proxy.newProxyInstance(type.getClassLoader(), new Class<?>[]{type}, handler);
    }

    private static Object defaultValue(Class<?> returnType) {
        if (!returnType.isPrimitive()) {
            return null;
        }
        if (boolean.class.equals(returnType)) {
            return false;
        }
        if (char.class.equals(returnType)) {
            return '\0';
        }
        return 0;
    }
}
