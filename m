From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 04:10:34 -0700
Message-ID: <20191028111034.GS2963@bombadil.infradead.org>
References: <157225848971.557.16257813537984792761.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <157225848971.557.16257813537984792761.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 28, 2019 at 01:28:09PM +0300, Konstantin Khlebnikov wrote:
> +	if (dax_mapping(mapping))
> +		pages = READ_ONCE(mapping->nrexceptional);
> +	else
> +		pages = READ_ONCE(mapping->nrpages);

I'm not sure this is the right calculation for DAX files.  We haven't
allocated any memory for DAX; we're just accessing storage directly.
The entries in the page caache are just translation from file offset to
physical address.
