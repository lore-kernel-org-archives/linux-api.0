From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH man] kcmp: Add KCMP_EPOLL_TFD description
Date: Tue, 15 Aug 2017 22:57:43 +0300
Message-ID: <20170815195743.GE14341@uranus>
References: <20170806073858.GB1916@uranus.lan>
 <1529b66d-5caa-7f34-251f-ec23428c418e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1529b66d-5caa-7f34-251f-ec23428c418e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 15, 2017 at 09:49:47PM +0200, Michael Kerrisk (man-pages) wrote:
> Hello Cyril,
> 
> 
> On 08/06/2017 09:38 AM, Cyrill Gorcunov wrote:
> >        KCMP_EPOLL_TFD
> >               Check whether the file descriptor idx1 of process pid1 present in epoll(7)
> >               instance described by idx2 of process  pid2.   The  argument  idx2  is  an
> >               address of structure where the target file is described.
> > 
> >                   struct kcmp_epoll_slot {
> >                        __u32 efd;
> >                        __u32 tfd;
> >                        __u64 toff;
> >                   };
> > 
> >               where  efd  is  epoll  file descriptor from epoll_create(2) call, tfd is a
> >               target file number, toff is a target file offset counted from zero.   Sev‐
> >               eral  different  targets  may  be registered with the same file descriptor
> >               number and setting specific offset helps to investigate each of them.
> 
> Thanks. I've applied this patch. Is there some example program that
> demonstrates the use of this feature?

Well, not as its own. There are a series floating around for CRIU not merged
yet since I need to rebase it on new CRIU release and resend, but there is
a sample https://lists.openvz.org/pipermail/criu/2017-February/036041.html
- the file added into epoll, then dup'ed and original is closed, so kcmp
with dup'ed instance should match kcmp call.

If you can wait I'll try to find some time on the week and rather update
kernel selftests for this new kcmp mode and CC you on the patch. Sounds OK?
