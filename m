From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 18/21] nd_btt: atomic sector updates
Date: Wed, 10 Jun 2015 09:34:34 +0200
Message-ID: <20150610073434.GC3369@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com> <20150609064425.GF9804@lst.de> <1433874431.32607.37.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433874431.32607.37.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vishal Verma <vishal.l.verma-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Vishal,

I'm mostly worried about handling scalability to large CPU counts
properly.  If you think this is the best way to handle it that fine,
but please document the decisions on the changelog in a similar form
to what you did below.
