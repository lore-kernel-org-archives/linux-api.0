From: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/4] seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get
 pidfd on listener trap
Date: Fri, 24 Jan 2020 12:09:37 -0800
Message-ID: <CAMp4zn_WXwxJ6Md4rgFzdAY_xea4TmVDdQc1iJDObEMm5Yc79g@mail.gmail.com>
References: <20200124091743.3357-1-sargun@sargun.me> <20200124091743.3357-4-sargun@sargun.me>
 <20200124180332.GA4151@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200124180332.GA4151@cisco>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 24, 2020 at 10:03 AM Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org> wrote:
>
> On Fri, Jan 24, 2020 at 01:17:42AM -0800, Sargun Dhillon wrote:
> > Currently, this just opens the group leader of the thread that triggere
> > the event, as pidfds (currently) are limited to group leaders.
>
> I don't love the semantics of this; when they're not limited to thread
> group leaders any more, we won't be able to change this. Is that work
> far off?
>
> Tycho

We would be able to change this in the future if we introduced a flag like
SECCOMP_USER_NOTIF_FLAG_PIDFD_THREAD which would send a
pidfd that's for the thread, and not just the group leader. The flag could
either be XOR with SECCOMP_USER_NOTIF_FLAG_PIDFD, or
could require both. Alternatively, we can rename
SECCOMP_USER_NOTIF_FLAG_PIDFD to
SECCOMP_USER_NOTIF_FLAG_GROUP_LEADER_PIDFD.
