From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2] pci: export class IDs from pci_ids.h
Date: Thu, 2 Apr 2015 15:53:47 -0500
Message-ID: <20150402205347.GA10892@google.com>
References: <1427714755-16873-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427714755-16873-1-git-send-email-mst@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Alexei Starovoitov <ast@plumgrid.com>, stephen hemminger <stephen@networkplumber.org>, Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-pci@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 01:33:28PM +0200, Michael S. Tsirkin wrote:
> The basic class ID macros in pci_ids.h are pretty useful for userspace
> using the pci sysfs interface, and they aren't fundamentally different
> from the constants in pci_regs.h - both are defined in the
> pci spec.
> 
> At the moment userspace is forced to duplicate these macros
> (e.g. QEMU does this, so do seabios, gpxe, and others), it is better to
> expose them in /usr/include/linux/pci_ids.h so everyone can just include
> this header.

I agree that it would be nice for applications to get these definitions
from a single place, but I'm not sure that include/uapi/linux/pci_ids.h
needs to be that place.

These constants are just copies of what's in the spec, and I don't think
you're suggesting that the constants are necessary to use a kernel API.

I know the kernel does provide access to values via sysfs "class" files,
but the kernel is just passing the values through from the hardware.
That's analogous to reading the class with setpci, and I don't think it
leads to a requirement that the kernel export all the information about how
to interpret the class values.

I haven't looked at libpci or libudev, but it sounds like you think those
are not good solutions.  Is that because they don't currently have this
information?  People don't want to add dependencies on them?

Bjorn
