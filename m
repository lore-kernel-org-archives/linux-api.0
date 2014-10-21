From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Tue, 21 Oct 2014 14:23:00 +0200
Message-ID: <CAG8rG2wfwR0gYRk-8abe7Z7Z7WZ8FdH6qURVw9up==Z0DsrUkg@mail.gmail.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
	<1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com>
	<CALCETrWzxjpKrou6J63_T75x=ZEGWCGbc4KEWT_AMvzSQNn1eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrWzxjpKrou6J63_T75x=ZEGWCGbc4KEWT_AMvzSQNn1eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 11:37 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Oct 13, 2014 at 6:09 AM, Antonios Motakis
> <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org> wrote:
>> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
>> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
>> This way the user can control whether the XN flag will be set on the
>> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
>> the IOMMUs of the container used.
>
> Since you sent this to the linux-api list, I'll bite: what's the XN
> flag?  I know what PROT_EXEC does when you mmap something, and I
> presume that vfio is mmappable, but I don't actually have any clue
> what this patch does.
>
> I assume that this does not have anything to do with a non-CPU DMA
> master executing code in main memory, because that makes rather little
> sense.  (Or maybe it really does, in which case: weird.)

It does actually. For example, the ARM PL330 DMA controller will fetch
from memory code with DMA instructions, and it will respect this flag.
It is not code that can be executed on the CPU of course, but it is
executable on the DMAC.


>
> --Andy



-- 
Antonios Motakis
Virtual Open Systems
