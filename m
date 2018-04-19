From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [RFC PATCH ghak32 V2 02/13] audit: check children and threading
	before allowing containerid
Date: Wed, 18 Apr 2018 20:11:30 -0400
Message-ID: <CAHC9VhTSfpXDGg7LeUjh3SvN_GVvAP2f89MHmYKskdzGkR8u6Q@mail.gmail.com>
References: <cover.1521179281.git.rgb@redhat.com>
	<995b77557010b2f9aed0e10435f7b8536df7a5db.1521179281.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <995b77557010b2f9aed0e10435f7b8536df7a5db.1521179281.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux-Audit Mailing List <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 16, 2018 at 5:00 AM, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Check if a task has existing children or co-threads and refuse to set
> the container ID if either are present.  Failure to check this could
> permit games where a child scratches its parent's back to work around
> inheritance and double-setting policy.
>
> Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/auditsc.c | 4 ++++
>  1 file changed, 4 insertions(+)

I would just include this in patch 1/2 as I can't think of world where
we wouldn't this check.

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 29c8482..a6b0a52 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2087,6 +2087,10 @@ static int audit_set_containerid_perm(struct task_struct *task, u64 containerid)
>         /* if we don't have caps, reject */
>         if (!capable(CAP_AUDIT_CONTROL))
>                 return -EPERM;
> +       /* if task has children or is not single-threaded, deny */
> +       if (!list_empty(&task->children) ||
> +           !(thread_group_leader(task) && thread_group_empty(task)))
> +               return -EPERM;
>         /* if containerid is unset, allow */
>         if (!audit_containerid_set(task))
>                 return 0;
> --
> 1.8.3.1

-- 
paul moore
www.paul-moore.com
