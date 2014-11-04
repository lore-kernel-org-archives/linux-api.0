From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 0/7] CGroup Namespaces
Date: Tue, 4 Nov 2014 08:10:30 -0500
Message-ID: <20141104131030.GA2937@redhat.com>
References: <adityakali-cgroupns>
	<1414783141-6947-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1414783141-6947-1-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 12:18:54PM -0700, Aditya Kali wrote:
[..]
>  fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
>  fs/kernfs/mount.c                |  48 ++++++++++
>  fs/proc/namespaces.c             |   1 +
>  include/linux/cgroup.h           |  41 ++++++++-
>  include/linux/cgroup_namespace.h |  36 ++++++++
>  include/linux/kernfs.h           |   5 +
>  include/linux/nsproxy.h          |   2 +
>  include/linux/proc_ns.h          |   4 +
>  include/uapi/linux/sched.h       |   3 +-
>  kernel/Makefile                  |   2 +-
>  kernel/cgroup.c                  | 108 +++++++++++++++++-----
>  kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
>  kernel/fork.c                    |   2 +-
>  kernel/nsproxy.c                 |  19 +++-

Hi Aditya,

Can we provide a documentation file for cgroup namespace behavior. Say,
Documentation/namespaces/cgroup-namespace.txt.

Namespaces are complicated and it might be a good idea to keep one .txt
file for each namespace.

Thanks
Vivek
