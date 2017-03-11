From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add option to mount only a pids subset
Date: Sat, 11 Mar 2017 01:05:55 +0100
Message-ID: <20170311000555.GE4554@comp-core-i7-2640m-0182e6>
References: <20170221145746.GA31914@redhat.com>
 <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
 <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVFnSoBP+LvyjN+1qUqrwgZan1nvscq5hV0Ujt_FF2e3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 07, 2017 at 08:24:12AM -0800, Andy Lutomirski wrote:
> On Mon, Mar 6, 2017 at 3:05 PM, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > After discussion with Oleg Nesterov I reimplement my patch as an additional
> > option for /proc. This option affects the mountpoint. It means that in one
> > pid namespace it possible to have both the whole traditional /proc and
> > /proc with only pids subset.
> >
> 
> I like this.  I think you should split it into two patches, though:
> one that reworks how procfs gets mounted and one that makes adds the
> new functionality.

Sure, but first I wanted to discuss the idea. My patch isn't very useful
without the ability to add additional files.

I will split it into parts in the new version.

-- 
Rgrds, legion
