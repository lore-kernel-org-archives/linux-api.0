From: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Tue, 11 Feb 2020 15:32:26 -0800
Message-ID: <CADyq12ySxau=SyyNp6VSbwmvRm6Kq1=Y62wTbQZoEAQ1XaXcuw@mail.gmail.com>
References: <20200207201856.46070-1-bgeffon@google.com> <CAKOZuevHH1pamEKy5n5RLWDP=tHk6_9bR+g3G+HKnqm_srHvrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKOZuevHH1pamEKy5n5RLWDP=tHk6_9bR+g3G+HKnqm_srHvrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nathan Chancellor <natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Daniel,

> What about making the
> left-behind mapping PROT_NONE? This way, we'll still solve the
> address-space race in Lokesh's use case (because even a PROT_NONE
> mapping reserves address space) but won't incur any additional commit
> until someone calls mprotect(PROT_WRITE) on the left-behind mapping.

This limits the usefulness of the feature IMO and really is too
specific to that one use case, suppose you want to snapshot a memory
region to disk without having to stop a thread you can
mremap(MREMAP_DONTUNMAP) it to another location and safely write it to
disk knowing the faulting thread will be stopped and you can handle it
later if it was registered with userfaultfd, if we were to also change
it to PROT_NONE that thread would see a SEGV. There are other examples
where you can possibly use this flag instead of VM_UFFD_WP, but
changing the protections of the mapping prevents you from being able
to do this without a funny signal handler dance.

Brian
