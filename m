From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 11/13] mm/vas: Introduce VAS segments - shareable
 address space regions
Date: Mon, 13 Mar 2017 15:27:58 -0700
Message-ID: <20170313222758.GB4033@bombadil.infradead.org>
References: <20170313221415.9375-1-till.smejkal@gmail.com>
 <20170313221415.9375-12-till.smejkal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170313221415.9375-12-till.smejkal@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Till Smejkal <till.smejkal@googlemail.com>
Cc: linux-mips@linux-mips.org, linux-s390@vger.kernel.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, alsa-devel@alsa-project.org, linux-usb@vger.kernel.org, "James E.J. Bottomley" <jejb@parisc-linux.org>, "J. Bruce Fields" <bfields@fieldses.org>, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org, linux-hexagon@vger.kernel.org, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Andy Lutomirski <luto@amacapital.net>, Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.orgBoris Brezillon <bo>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 13, 2017 at 03:14:13PM -0700, Till Smejkal wrote:
> +/**
> + * Create a new VAS segment.
> + *
> + * @param[in] name:		The name of the new VAS segment.
> + * @param[in] start:		The address where the VAS segment begins.
> + * @param[in] end:		The address where the VAS segment ends.
> + * @param[in] mode:		The access rights for the VAS segment.
> + *
> + * @returns:			The VAS segment ID on success, -ERRNO otherwise.
> + **/

Please follow the kernel-doc conventions, as described in
Documentation/doc-guide/kernel-doc.rst.  Also, function documentation
goes with the implementation, not the declaration.

> +/**
> + * Get ID of the VAS segment belonging to a given name.
> + *
> + * @param[in] name:		The name of the VAS segment for which the ID
> + *				should be returned.
> + *
> + * @returns:			The VAS segment ID on success, -ERRNO
> + *				otherwise.
> + **/
> +extern int vas_seg_find(const char *name);

So ... segments have names, and IDs ... and access permissions ...
Why isn't this a special purpose filesystem?


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
