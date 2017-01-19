From: Michal Hocko <mhocko@kernel.org>
Subject: Re: writev error codes
Date: Thu, 19 Jan 2017 08:34:25 +0100
Message-ID: <20170119073425.GC30786@dhcp22.suse.cz>
References: <20170118154431.GD7021@dhcp22.suse.cz>
 <CAKgNAkgWN6Fkx0UqE7Hu6RV82funbbP4OJM0yNK9wiE=0FAMxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkgWN6Fkx0UqE7Hu6RV82funbbP4OJM0yNK9wiE=0FAMxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 19-01-17 15:09:52, Michael Kerrisk wrote:
> Hello Michal,
> 
> On 19 January 2017 at 04:44, Michal Hocko <mhocko@kernel.org> wrote:
> > Hi,
> > we have noticed that one of the LTP tests started to fail after
> > 99526912c934 ("fix iov_iter_fault_in_readable()"). The code has expected
> > EINVAL while it gets EFAULT. I believe the new behavior is reasonable,
> > but checking the man 2 writev, there is no mention about EFAULT,
> > and other errnos for that matter, so it seems this is rather under
> > documented and it can confuse users. LTP has been fixed in the meantime
> > [1] but this might come unexpected to others.
> >
> > In principle writev as a write
> > "multiplier" should be allowed all the error codes that write(2) allows,
> > right? I am not sure how we should reflect that. Either c&p what we have
> > in man 2 write or put a reference to it and only describe writev
> > specific, if there are any (I haven't checked that).
> >
> > [1] https://github.com/linux-test-project/ltp/commit/db19194527060a962955a7db54a2f5710e69bec9
> 
> Perhaps I am misunderstanding you, but in the writev(2) page there is the text:
> 
>     ERRORS
>        The  errors  are  as given for read(2) and write(2).  Furthermore,
>        preadv(), preadv2(), pwritev(), and pwritev2() can also  fail  for
>        the  same reasons as lseek(2).

This has hit right to the blind spot. Sorry about the noise!

> 
> And in the write(2) page, we have:
> 
>        EFAULT buf is outside your accessible address space.
> 
> Does this not cover the case you describe?

Yes

-- 
Michal Hocko
SUSE Labs
