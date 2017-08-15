From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Date: Tue, 15 Aug 2017 09:29:30 -0700
Message-ID: <CAPcyv4h01os0Gc6bYmaGdMXt5q4G4zfirNRPWG3=gQi5POrpmg@mail.gmail.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170815124250.GG27505@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815124250.GG27505-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 15, 2017 at 5:42 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Mon 14-08-17 23:12:22, Dan Williams wrote:
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index ff151814a02d..73fdc0ada9ee 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -306,6 +306,7 @@ struct vm_area_struct {
>>       struct mm_struct *vm_mm;        /* The address space we belong to. */
>>       pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
>>       unsigned long vm_flags;         /* Flags, see mm.h. */
>> +     unsigned long fs_flags;         /* fs flags, see MAP_DIRECT etc */
>>
>>       /*
>>        * For areas with an address space and backing store,
>
> Ah, OK, here are VMA flags I was missing in the previous patch :) But why
> did you create separate fs_flags field for this? on 64-bit archs there's
> still space in vm_flags and frankly I don't see why we should separate
> MAP_DIRECT or MAP_SYNC from other flags?

Where would MAP_DIRECT go in the 32-bit case?

> After all a difference in these
> flags must also prevent VMA merging (which you forgot to handle I think)
> and they need to be copied on split (which happens by chance even now).

Ah, yes I did miss blocking the merge of a vma with MAP_DIRECT and one
without. However, the vma split path looks ok.
