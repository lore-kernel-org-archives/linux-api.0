From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [CFT][PATCH 6/8] userns: Rename id_map_mutex to userns_state_mutex
Date: Tue, 9 Dec 2014 14:49:32 -0800
Message-ID: <CALCETrXffwu6+yn76FXB2xnk+2GQq5UZSxXokOk8pxsHz6Ye_Q@mail.gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	<87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
	<87mw6wk12i.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87mw6wk12i.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 9, 2014 at 12:41 PM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Generalize id_map_mutex so it can be used for more state of a user namespace.

Reviewed-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>

>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  kernel/user_namespace.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 1e34de2fbd60..44a555ac6104 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -24,6 +24,7 @@
>  #include <linux/fs_struct.h>
>
>  static struct kmem_cache *user_ns_cachep __read_mostly;
> +static DEFINE_MUTEX(userns_state_mutex);
>
>  static bool new_idmap_permitted(const struct file *file,
>                                 struct user_namespace *ns, int cap_setid,
> @@ -583,9 +584,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map,
>         return false;
>  }
>
> -
> -static DEFINE_MUTEX(id_map_mutex);
> -
>  static ssize_t map_write(struct file *file, const char __user *buf,
>                          size_t count, loff_t *ppos,
>                          int cap_setid,
> @@ -602,7 +600,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>         ssize_t ret = -EINVAL;
>
>         /*
> -        * The id_map_mutex serializes all writes to any given map.
> +        * The userns_state_mutex serializes all writes to any given map.
>          *
>          * Any map is only ever written once.
>          *
> @@ -620,7 +618,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>          * order and smp_rmb() is guaranteed that we don't have crazy
>          * architectures returning stale data.
>          */
> -       mutex_lock(&id_map_mutex);
> +       mutex_lock(&userns_state_mutex);
>
>         ret = -EPERM;
>         /* Only allow one successful write to the map */
> @@ -750,7 +748,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>         *ppos = count;
>         ret = count;
>  out:
> -       mutex_unlock(&id_map_mutex);
> +       mutex_unlock(&userns_state_mutex);
>         if (page)
>                 free_page(page);
>         return ret;
> @@ -845,12 +843,12 @@ bool userns_may_setgroups(const struct user_namespace *ns)
>  {
>         bool allowed;
>
> -       mutex_lock(&id_map_mutex);
> +       mutex_lock(&userns_state_mutex);
>         /* It is not safe to use setgroups until a gid mapping in
>          * the user namespace has been established.
>          */
>         allowed = ns->gid_map.nr_extents != 0;
> -       mutex_unlock(&id_map_mutex);
> +       mutex_unlock(&userns_state_mutex);
>
>         return allowed;
>  }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
