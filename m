From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 19/21] userfaultfd: remap_pages: UFFDIO_REMAP preparation
Date: Thu, 5 Mar 2015 11:32:24 -0800
Message-ID: <CA+55aFzK7kyZH0eiBH2CNDJ+p0oQYDZpm8tZitTgedOJz_He5Q@mail.gmail.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
	<1425575884-2574-20-git-send-email-aarcange@redhat.com>
	<CA+55aFzW=qaO0iKZWK9BWDNHu4eOgiKOJ-=0SvzsmZawuH5_3A@mail.gmail.com>
	<20150305185112.GL4280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150305185112.GL4280-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Johannes Weiner <hannes@cmpxchg.>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 5, 2015 at 10:51 AM, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Thanks for your idea that the UFFDIO_COPY is faster, the userland code
> we submitted for qemu only uses UFFDIO_COPY|ZEROPAGE, it never uses
> UFFDIO_REMAP.

Ok. So there's no actual expected use of the remap interface. Good.
That makes this series more palatable, since the rest didn't raise my
hackles much.

(But yeah, the documentation patch didn't really explain the uses very
much or at all, so I think something more is needed in that area).

                   Linus
