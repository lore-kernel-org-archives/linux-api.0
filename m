From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Wed, 22 Oct 2014 15:42:00 -0400
Message-ID: <20141022194200.GA24009@htj.dyndns.org>
References: <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
	<87lhoayo59.fsf@x220.int.ebiederm.org>
	<CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
	<CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
	<CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com>
	<CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw@mail.gmail.com>
	<CALCETrXEAegFmSs2LnfSJR0tQmqZudnESDER8CoqKxOCBFMwdA@mail.gmail.com>
	<CAGr1F2HYGG9=jwugywD8tUdB+dOjN4z+3BSpqL_m2aaM+3Rz1A@mail.gmail.com>
	<CALCETrUtqozUE=Lr5d2dBKd_vaLzfVvVv8g6ZALz1MWqVzj9dQ@mail.gmail.com>
	<CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Oct 22, 2014 at 11:37:55AM -0700, Aditya Kali wrote:
...
> Actually, there is no right answer here. Our options are:
> * show relative path
> -- this will break userspace as /proc/<pid>/cgroup does not show
> relative paths today. This is also very ambiguous (is it relative to
> cgroupns-root or relative to /proc/<pid>cgroup file reader's cgroup?).

Let's go with this w/o pinning.  The only necessary feature for
cgroupns is making the /proc/*/cgroups relative to its own root.  It's
not like containers can avoid trusting its outside world anyway and
playing tricks with things like this tend to lead to weird surprises
down the road.  If userland messes up, userland messes up.

Thanks.

-- 
tejun
