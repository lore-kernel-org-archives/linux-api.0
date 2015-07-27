From: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] pci_regs: reintroduce PCI_MSIX_FLAGS_BIRMASK
Date: Mon, 27 Jul 2015 11:13:46 -0500
Message-ID: <CAErSpo53wL1NURkiFUOMHDfY0MWrNE0jXwED20uiXXOiRDSB7g@mail.gmail.com>
References: <1435745608-21217-1-git-send-email-mst@redhat.com>
 <20150713181025-mutt-send-email-mst@redhat.com> <20150714232924.GS24416@google.com>
 <20150727175412-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727175412-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rajat Jain <rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Guenter Roeck <groeck-3r7Miqu9kMnR7s880joybQ@public.gmane.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 27, 2015 at 9:55 AM, Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Jul 14, 2015 at 06:29:24PM -0500, Bjorn Helgaas wrote:
>> On Mon, Jul 13, 2015 at 06:11:38PM +0300, Michael S. Tsirkin wrote:
>> > On Wed, Jul 01, 2015 at 12:14:10PM +0200, Michael S. Tsirkin wrote:
>> > > This partially reverts commit 09a2c73ddfc7f173237fc7209a65b34dd5bcb5ed.
>> > >     PCI: Remove unused PCI_MSIX_FLAGS_BIRMASK definition
>> > >
>> > > That commit dropped a symbol from an exported header claiming "no one
>> > > uses it". This isn't how Linux normally approaches userspace API though,
>> > > and in fact QEMU build fails if trying to use updated headers from linux
>> > > 3.12 and up.
>> > >
>> > > Sure, userspace can be fixed to use the new symbol, but the cost
>> > > of keeping the old one around is fairly low, too.
>> > >
>> > > Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Sorry, I lost the original message somehow, so I can't reply to it.  I
>> applied this by hand to my for-linus branch for v4.2, thanks!
>
>
>
> Did you mean 4.2? time's running out on this one ...
> Just making sure - it's still not upstream, right?

It's on my for-linus branch and it's been in -next for a couple weeks.
We're at -rc4, and I will send a pull request to Linus before v4.2
releases.  This is a really minor fix, so I'm holding it in case there
are other fixes that I can include in the same request.

>> commit c9ddbac9c89110f77cb0fa07e634aaf1194899aa
>> Author: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Date:   Tue Jul 14 18:27:46 2015 -0500
>>
>>     PCI: Restore PCI_MSIX_FLAGS_BIRMASK definition
>>
>>     09a2c73ddfc7 ("PCI: Remove unused PCI_MSIX_FLAGS_BIRMASK definition")
>>     removed PCI_MSIX_FLAGS_BIRMASK from an exported header because it was
>>     unused in the kernel.  But that breaks user programs that were using it
>>     (QEMU in particular).
>>
>>     Restore the PCI_MSIX_FLAGS_BIRMASK definition.
>>
>>     [bhelgaas: changelog]
>>     Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>     Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>     CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org        # v3.13+
>>
>> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
>> index efe3443..413417f 100644
>> --- a/include/uapi/linux/pci_regs.h
>> +++ b/include/uapi/linux/pci_regs.h
>> @@ -319,6 +319,7 @@
>>  #define PCI_MSIX_PBA         8       /* Pending Bit Array offset */
>>  #define  PCI_MSIX_PBA_BIR    0x00000007 /* BAR index */
>>  #define  PCI_MSIX_PBA_OFFSET 0xfffffff8 /* Offset into specified BAR */
>> +#define PCI_MSIX_FLAGS_BIRMASK       PCI_MSIX_PBA_BIR /* deprecated */
>>  #define PCI_CAP_MSIX_SIZEOF  12      /* size of MSIX registers */
>>
>>  /* MSI-X Table entry format */
