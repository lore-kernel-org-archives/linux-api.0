From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [patch v4 resend 2/2] kcmp: Add KCMP_EPOLL_TFD mode to compare
 epoll target files
Date: Fri, 12 May 2017 18:45:09 -0700
Message-ID: <20170513014508.GA21900@outlook.office365.com>
References: <20170424154423.511592110@gmail.com>
 <CAG48ez33xco_cHeaHYg2TOCquosbrAStnHikBDZ89No6c7E0Kg@mail.gmail.com>
 <20170512225340.GD1881@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170512225340.GD1881-ZmlpmtaulQd+urZeOPWqwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, May 13, 2017 at 01:53:40AM +0300, Cyrill Gorcunov wrote:
> On Sat, May 13, 2017 at 12:41:30AM +0200, Jann Horn wrote:
> > [resending as plaintext]
> > 
> > I realize that the existing kcmp code has the same issue, but:
> > 
> > Why are you not taking a reference to filp or filp_tgt? This can end up
> > performing a comparison between a pointer to a freed struct file and a
> > pointer to a struct file that was allocated afterwards, right? So it can
> > return a false "is equal" result when the two files aren't actually the same
> > if one of the target tasks is running? This looks like it unnecessarily
> > exposes information about whether an allocation reuses the memory of
> > a previously freed allocation.
> 
> It work with unlocked data on purpose for speed sake. Moreover even
> if we grap a reference it is valid _only_ during comparision operation,
> next we drop ref and it can be easily freed by os. Thus it's up to
> a caller to keep references to files/task and other resources used.

Looks like we can take rcu_read_lock() to guarantee that these objects
will not be freed, and rcu_read_lock() should not affect perfomance too much.

> 
> 	Cyrill
