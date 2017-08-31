From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
	safely defining new mmap flags
Date: Thu, 31 Aug 2017 12:03:59 +0200
Message-ID: <20170831100359.GD21443@lst.de>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com> <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, hch@lst.de
List-Id: linux-api@vger.kernel.org

> +/*
> + * The historical set of flags that all mmap implementations implicitly
> + * support when file_operations.mmap_supported_mask is zero. With the
> + * mmap3 syscall the deprecated MAP_DENYWRITE and MAP_EXECUTABLE bit
> + * values are explicitly rejected with EOPNOTSUPP rather than being
> + * silently accepted.
> + */

no mmap3 syscall here :)

Do you also need to update the nommu mmap implementation?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
