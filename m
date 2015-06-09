From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 02/21] libnvdimm, nfit: initial libnvdimm
 infrastructure and NFIT support
Date: Tue, 9 Jun 2015 15:27:09 -0700
Message-ID: <CAPcyv4jfy9Yg1u5Qj736X3n9muW-Jkt_Ka-zPFDEtn8bMXmqoA@mail.gmail.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001419.4506.41953.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150603145704.GA22311@lst.de>
	<1433359473.21035.27.camel@intel.com>
	<20150609063312.GA9804@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20150609063312.GA9804@lst.de>
Sender: linux-acpi-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "neilb@suse.de" <neilb@suse.de>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "rafael@kernel.org" <rafael@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 8, 2015 at 11:33 PM, hch@lst.de <hch@lst.de> wrote:
> On Wed, Jun 03, 2015 at 07:24:34PM +0000, Williams, Dan J wrote:
>> > > +static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfit_mem)
>> >
>> > This line is over 80 characters.
>>
>> I generally don't see the point of fixing up occasional small incursions
>> over 80 characters if it makes the code more amenable to grep.
>
> Just use shorter type names or add a line break before the symbol
> names.  Too long lines are highly annoying.

Note that "acpi_nfit_memory_map" is the identifier chosen by ACPICA,
I'm just a consumer.  That said I've gone and done a 80 column cleanup
across all the patches.
