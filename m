From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/23] userfaultfd: linux/Documentation/vm/userfaultfd.txt
Date: Fri, 4 Dec 2015 18:55:03 +0100
Message-ID: <20151204175503.GZ29105@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-2-git-send-email-aarcange@redhat.com>
 <55F29513.4030503@gmail.com>
 <5661B62B.2020409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5661B62B.2020409-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Michael,

On Fri, Dec 04, 2015 at 04:50:03PM +0100, Michael Kerrisk (man-pages) wrote:
> Hi Andrea,
> 
> On 09/11/2015 10:47 AM, Michael Kerrisk (man-pages) wrote:
> > On 05/14/2015 07:30 PM, Andrea Arcangeli wrote:
> >> Add documentation.
> > 
> > Hi Andrea,
> > 
> > I do not recall... Did you write a man page also for this new system call?
> 
> No response to my last mail, so I'll try again... Did you 
> write any man page for this interface?

I wished I would answer with the manpage itself to give a more
satisfactory answer, but answer is still no at this time. Right now
there's the write protection tracking feature posted to linux-mm and
I'm currently reviewing that. It's worth documenting that part too in
the manpage as it's going to happen sooner than later.

Lack of manpage so far didn't prevent userland to use it (qemu
postcopy is already in upstream qemu and it depends on userfaultfd),
nor review of the code nor other kernel contributors to extend the
syscall API. Other users started testing the syscall too. This is just
to explain why unfortunately the manpage didn't get the top priority
yet, but nevertheless the manpage should happen too and it's
important. Advice on how to proceed is welcome.

Thanks,
Andrea
