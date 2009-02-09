From: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Driver for user access to internal clocks
Date: Mon, 9 Feb 2009 18:54:12 +0100
Message-ID: <8447d6730902090954p454a3310o3fc2f5fefbde04f7@mail.gmail.com>
References: <8447d6730901080149l4146139an9fad00fd88d72fb9@mail.gmail.com>
	 <20090108112741.GA3053@local>
	 <8447d6730901080806r238354c7u81071a28d8b483ff@mail.gmail.com>
	 <20090108163024.GB26413@suse.de>
	 <8447d6730901281117g3a8b7ddfp26e937111b6b6304@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8447d6730901281117g3a8b7ddfp26e937111b6b6304-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-xIg/pKzrS19vn6HldHNs0ANdhmdF6hFW@public.gmane.org
Cc: ben-linux-elnMNo+KYs3YtjvyW6yDsg@public.gmane.org, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a proposal for adding 2 functions to clk interface to allow higher
 level drivers to enumerate and list all clocks, and to modify clk_get
 to accept device specific clk names in the form "name.id"
There is also the implementation for Samsung S3C24xx platform.

Signed-off-by: Davide Rizzo <elpa.rizzo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---diff -urpN linux-2.6.29-rc2/arch/arm/plat-s3c/clock.c
linux-2.6.29-rc2.elpa/arch/arm/plat-s3c/clock.c
--- linux-2.6.29-rc2/arch/arm/plat-s3c/clock.c  2009-01-17
11:32:38.000000000 +0100
+++ linux-2.6.29-rc2.elpa/arch/arm/plat-s3c/clock.c     2009-01-28
19:32:08.000000000 +0100
@@ -69,11 +69,19 @@ static int clk_null_enable(struct clk *c

 struct clk *clk_get(struct device *dev, const char *id)
 {
+       long idno;
+       char *name = (char *)id;
+       char *dotpos = strrchr(id, '.');
       struct clk *p;
       struct clk *clk = ERR_PTR(-ENOENT);
-       int idno;

-       if (dev == NULL || dev->bus != &platform_bus_type)
+       if (dotpos) {
+               int err = strict_strtol(dotpos + 1, 10, &idno);
+               if (err)
+                               return ERR_PTR(err);
+               name = kstrdup(id, GFP_KERNEL);
+               name[dotpos - id] = '\0';
+       } else if (dev == NULL || dev->bus != &platform_bus_type)
               idno = -1;
       else
               idno = to_platform_device(dev)->id;
@@ -82,7 +90,7 @@ struct clk *clk_get(struct device *dev,

       list_for_each_entry(p, &clocks, list) {
               if (p->id == idno &&
-                   strcmp(id, p->name) == 0 &&
+                   strcmp(name, p->name) == 0 &&
                   try_module_get(p->owner)) {
                       clk = p;
                       break;
@@ -94,7 +102,7 @@ struct clk *clk_get(struct device *dev,

       if (IS_ERR(clk)) {
               list_for_each_entry(p, &clocks, list) {
-                       if (p->id == -1 && strcmp(id, p->name) == 0 &&
+                       if (p->id == -1 && strcmp(name, p->name) == 0 &&
                           try_module_get(p->owner)) {
                               clk = p;
                               break;
@@ -103,6 +111,8 @@ struct clk *clk_get(struct device *dev,
       }

       spin_unlock(&clocks_lock);
+       if (dotpos)
+               kfree(name);
       return clk;
 }

@@ -222,6 +232,42 @@ EXPORT_SYMBOL(clk_set_rate);
 EXPORT_SYMBOL(clk_get_parent);
 EXPORT_SYMBOL(clk_set_parent);

+int clk_for_each(int(*fn)(struct clk *, void *), void *data)
+       {
+       struct clk *clk;
+       int ret = 0;
+
+       list_for_each_entry(clk, &clocks, list)
+       {
+               ret = fn(clk, data);
+               if (ret)
+                       break;
+       }
+       return ret;
+}
+EXPORT_SYMBOL(clk_for_each);
+
+/* Returned pointer must be deallocated with kfree() */
+const char *clk_get_name(struct clk *clk)
+{
+       char *s;
+       int len;
+
+       if (IS_ERR(clk))
+               return ERR_PTR(-EINVAL);
+
+       len = strlen(clk->name) + 8;
+       s = kmalloc(len, GFP_KERNEL);
+       if (!s)
+               return ERR_PTR(-ENOMEM);
+       if (clk->id == -1)
+               strlcpy(s, clk->name, len);
+       else if (snprintf(s, len, "%s.%d", clk->name, clk->id) > len)
+               s[len - 1] = '\0';
+       return s;
+}
+EXPORT_SYMBOL(clk_get_name);
+
 /* base clocks */

 static int clk_default_setrate(struct clk *clk, unsigned long rate)
diff -urpN linux-2.6.29-rc2/include/linux/clk.h
linux-2.6.29-rc2.elpa/include/linux/clk.h
--- linux-2.6.29-rc2/include/linux/clk.h        2008-12-25
00:26:37.000000000 +0100
+++ linux-2.6.29-rc2.elpa/include/linux/clk.h   2009-01-28
19:21:43.000000000 +0100
@@ -125,4 +125,22 @@ int clk_set_parent(struct clk *clk, stru
 */
 struct clk *clk_get_parent(struct clk *clk);

+/**
+ * clk_for_each - calls fn, iterating between registered clocks
+ * @fn: function to be called, passing each clk structure in 1st argument
+ * @data: 2nd argument to pass to fn function
+ *
+ * Returns 0 or the called fn return code if != 0
+ */
+int clk_for_each(int(*fn)(struct clk *, void *), void *data);
+
+/**
+ * clk_name - get clock name
+ * @clk: clock source
+ *
+ * Returns clock's name that must be deallocated with kfree(), or valid
+ * IS_ERR() condition containing errno.
+ */
+const char *clk_get_name(struct clk *clk);
+
 #endif
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
