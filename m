From: Christian Brauner <christian@brauner.io>
Subject: Re: [RESEND PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Thu, 10 Jan 2019 15:50:05 +0100
Message-ID: <20190110145004.zhc2t42aasni7wnq@brauner.io>
References: <20190107222700.15954-1-christian@brauner.io>
 <20190107222700.15954-3-christian@brauner.io>
 <20190108070110.GA7998@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190108070110.GA7998@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 08, 2019 at 08:01:10AM +0100, Dominik Brodowski wrote:
> On Mon, Jan 07, 2019 at 11:27:00PM +0100, Christian Brauner wrote:
> > @@ -2833,6 +2836,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
> >  				break;
> >  			if (neg)
> >  				continue;
> > +			if ((max && val > *max) || (min && val < *min)) {
> > +				err = -EINVAL;
> > +				break;
> > +			}
> >  			val = convmul * val / convdiv;
> >  			if ((min && val < *min) || (max && val > *max))
> >  				continue;
> 
> This is a generic change which affects all users of
> do_proc_doulongvec_minmax() that have extra1 or extra2 set. In sysctl.c, I
> do not see another user of proc_doulongvec_minmax() that has extra1 or
> extra2 set. However, have you verified whether your patch changes the
> behaviour for other files that make use of proc_doulongvec_minmax() or
> proc_doulongvec_ms_jiffies_minmax(), and not only of the file-max sysctl?

Sorry for the delayed reply. I did look at the callers. The functions
that are of interest afaict are:

proc_doulongvec_ms_jiffies_minmax
proc_doulongvec_minmax

So this could be visible when users write values that would overflow the
type used in the kernel.
I guess your point is whether we are venturing into userspace break
territory. Hm... We should probably make sure that we're not regressing
anyone else! What do you think if instead of the above patch we did:

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ba4d9e85feb8..37727b4c7a97 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1721,7 +1721,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &files_stat.max_files,
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_file_max,
 	},
 	{
 		.procname	= "nr_open",
@@ -2758,7 +2758,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
 				     unsigned long convmul,
-				     unsigned long convdiv)
+				     unsigned long convdiv, bool strict)
 {
 	unsigned long *i, *min, *max;
 	int vleft, first = 1, err = 0;
@@ -2806,7 +2806,12 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 				continue;
 			val = convmul * val / convdiv;
 			if ((min && val < *min) || (max && val > *max))
-				continue;
+				if (strict) {
+					err = -EINVAL;
+					break;
+				} else {
+					continue;
+				}
 			*i = val;
 		} else {
 			val = convdiv * (*i) / convmul;
@@ -2843,7 +2848,15 @@ static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 				     unsigned long convdiv)
 {
 	return __do_proc_doulongvec_minmax(table->data, table, write,
-			buffer, lenp, ppos, convmul, convdiv);
+			buffer, lenp, ppos, convmul, convdiv, false);
+}
+
+static int proc_file_max(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos,
+			 unsigned long convmul, unsigned long convdiv)
+{
+	return __do_proc_doulongvec_minmax(table->data, table, write, buffer,
+					   lenp, ppos, convmul, convdiv, true);
 }
 
 /**
@@ -2865,7 +2878,8 @@ static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 int proc_doulongvec_minmax(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos, 1l, 1l);
+	return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos, 1l,
+					 1l, false);
 }
 
 /**
@@ -2890,7 +2904,7 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      size_t *lenp, loff_t *ppos)
 {
     return do_proc_doulongvec_minmax(table, write, buffer,
-				     lenp, ppos, HZ, 1000l);
+				     lenp, ppos, HZ, 1000l, false);
 }
