From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC v6 03/40] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
 permission flags
Date: Fri, 28 Aug 2015 18:04:30 -0700
Message-ID: <CALCETrWwftQ4jbrLqtnuaSA0z15c4V0qyXHL4X0q5vBochDgqg@mail.gmail.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
 <1438689218-6921-4-git-send-email-agruenba@redhat.com> <CALCETrUoBnPyEGExpoDzHOCgnHh5=a1ROALmb63LLJZG+L=aQA@mail.gmail.com>
 <CAHpGcM+i887PJ07_CNZ38aK0DhRWgmyYbAGrDN2i1xXkH+1rUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHpGcM+i887PJ07_CNZ38aK0DhRWgmyYbAGrDN2i1xXkH+1rUg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Aug 28, 2015 2:54 PM, "Andreas Gr=C3=BCnbacher"
<andreas.gruenbacher@gmail.com> wrote:
>
> 2015-08-28 23:36 GMT+02:00 Andy Lutomirski <luto@amacapital.net>:
> > Silly question from the peanut gallery: is there any such thing as
> > opening an fd pointing at a file such that the "open file descripti=
on"
> > (i.e. the struct file) captures the right to delete the file?
> >
> > IOW do we need FMODE_DELETE_SELF?
>
> When would that permission be checked, what syscall would you use to
> unlink an open file descriptor?

Good point.  It's remotely plausible that there's some trick with bind
mounts, it's likely possible to unlink a directory by fd (using
unlinkat), and you can *link* a file (with linkat or /proc), but
unlinkat doesn't appear to allow you to unlink a file by fd.

--Andy

>
> Thanks,
> Andreas
