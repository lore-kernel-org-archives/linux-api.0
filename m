From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] proc.5: Document the proc files for the user, mount,
	and pid namespaces.
Date: Thu, 27 Dec 2012 11:28:53 +0100
Message-ID: <CAKgNAkhz8B5jhuZeHHvKCmv=wJXGGs57SwLe5bswrD7j4Ko5kQ@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <87pq2zq3b6.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87pq2zq3b6.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On Tue, Nov 27, 2012 at 1:47 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Thanks. Applied.

Cheers,

Michael


> ---
>  man5/proc.5 |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/man5/proc.5 b/man5/proc.5
> index 840480d..eb612b9 100644
> --- a/man5/proc.5
> +++ b/man5/proc.5
> @@ -581,6 +581,58 @@ even if all processes in the namespace terminate.
>  The file descriptor can be passed to
>  .BR setns (2).
>  .TP
> +.IR /proc/[pid]/ns/user " (since Linux 3.8)"
> +Bind mounting this file (see
> +.BR mount (2))
> +to somewhere else in the filesystem keeps
> +the user namespace of the process specified by
> +.I pid
> +alive even if all processes currently in the namespace terminate.
> +
> +Opening this file returns a file handle for the user namespace
> +of the process specified by
> +.IR pid .
> +As long as this file descriptor remains open,
> +the user namespace will remain alive,
> +even if all processes in the namespace terminate.
> +The file descriptor can be passed to
> +.BR setns (2).
> +.TP
> +.IR /proc/[pid]/ns/pid " (since Linux 3.8)"
> +Bind mounting this file (see
> +.BR mount (2))
> +to somewhere else in the filesystem keeps
> +the PID namespace of the process specified by
> +.I pid
> +alive even if all processes currently in the namespace terminate.
> +
> +Opening this file returns a file handle for the PID namespace
> +of the process specified by
> +.IR pid .
> +As long as this file descriptor remains open,
> +the PID namespace will remain alive,
> +even if all processes in the namespace terminate.
> +The file descriptor can be passed to
> +.BR setns (2).
> +.TP
> +.IR /proc/[pid]/ns/mnt " (since Linux 3.8)"
> +Bind mounting this file (see
> +.BR mount (2))
> +to somewhere else in the filesystem keeps
> +the mount namespace of the process specified by
> +.I pid
> +alive even if all processes currently in the namespace terminate.
> +
> +Opening this file returns a file handle for the mount namespace
> +of the process specified by
> +.IR pid .
> +As long as this file descriptor remains open,
> +the mount namespace will remain alive,
> +even if all processes in the namespace terminate.
> +The file descriptor can be passed to
> +.BR setns (2).
> +
> +.TP
>  .IR /proc/[pid]/numa_maps " (since Linux 2.6.14)"
>  See
>  .BR numa (7).
> --
> 1.7.5.4
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
