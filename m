From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Tue, 30 Aug 2016 21:41:46 -0500
Message-ID: <20160831024146.GB21475@mail.hallyn.com>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
	<1472252891-4963-2-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472252891-4963-2-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 26, 2016 at 04:08:08PM -0700, Andrei Vagin wrote:
> From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> 
> Return -EPERM if an owning user namespace is outside of a process
> current user namespace.
> 
> v2: In a first version ns_get_owner returned ENOENT for init_user_ns.
>     This special cases was removed from this version. There is nothing
>     outside of init_user_ns, so we can return EPERM.
> 
> Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  fs/namespace.c                 |  6 ++++++
>  include/linux/proc_ns.h        |  1 +
>  include/linux/user_namespace.h |  7 +++++++
>  ipc/namespace.c                |  6 ++++++
>  kernel/cgroup.c                |  6 ++++++
>  kernel/pid_namespace.c         |  6 ++++++
>  kernel/user_namespace.c        | 24 ++++++++++++++++++++++++
>  kernel/utsname.c               |  6 ++++++
>  net/core/net_namespace.c       |  6 ++++++
>  9 files changed, 68 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 491b8f3..f985817 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -3368,10 +3368,16 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct user_namespace *mntns_get_owner(struct ns_common *ns)
> +{
> +	return to_mnt_ns(ns)->user_ns;

Hi - sorry to be pedantic here, but *_get_owner makes me think
it will grab a reference too.  A bit unfortunate, maybe it doesn't
matter, but would mntns_owner(), netns_owner(), etc be better?
