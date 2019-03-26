From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH V31 10/25] PCI: Lock down BAR access when the kernel is
 locked down
Date: Tue, 26 Mar 2019 13:55:39 -0700
Message-ID: <CALCETrW43Syz-deM-fGUCbWfA8tcsoCJJ5XqjFhpg+d0sNYDRA@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com> <20190326182742.16950-11-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326182742.16950-11-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andrew Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg59@google.com>, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 11:28 AM Matthew Garrett
<matthewgarrett@google.com> wrote:
>
> From: Matthew Garrett <mjg59@srcf.ucam.org>
>
> Any hardware that can potentially generate DMA has to be locked down in
> order to avoid it being possible for an attacker to modify kernel code,
> allowing them to circumvent disabled module loading or module signing.
> Default to paranoid - in future we can potentially relax this for
> sufficiently IOMMU-isolated devices.

Does this break vfio?

--Andy
