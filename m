From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 09/21] libnvdimm, nd_pmem: add libnvdimm support to
 the pmem driver
Date: Wed, 3 Jun 2015 00:44:24 -0700
Message-ID: <20150603074424.GA24949@infradead.org>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150602001458.4506.76492.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150602001458.4506.76492.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@ml01.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

This patch doesn't apply, as it seems to use some git magic.

But looking at it it's also wrong in that it mixes a file move
and actual changes to the file.
