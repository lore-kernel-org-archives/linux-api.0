Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9ED35675E;
	Mon, 28 Sep 2026 05:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572754; cv=none; b=kCWXtFRz19Y6KGQo67yuqx2FoJC39r1Vn1Soa1TFd5T2tBj3sXqe4hC/VshY5z3oAMeCHSZr+12ChNnNySLDl6IkefoLexC5a9vFP/KRuC9auF8dKdUWRiQfTcdfbzOuleAVlqMsASxUSTG3u7zjsxJ4YjUjN9682NRpB1ps6vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572754; c=relaxed/simple;
	bh=DCBM11/YsDsAJeJrJrcLh/3bh79c31FOub1VkMd0e0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eem5HhqzWBPsSaJnJqKX7be16oVsyXghlp+yRCj6sVS8hTLl0Gx5G9Esrk0bx1abF8j9Mek36r8WH0N3ZDPX7TeKmAKluNK8CNrmxClVhVhPAu0wX8PEDj03yPdGXL1s7qWP4PVqn5SU82ypGTL1iPQsrvYCk1QzSa5v+81xEkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pWh+GUF3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pWh+GUF3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9wXI30xoHEFIzp1nZZ3HcM6IjWcoLUOaEIDAeAGQdHQ=; b=pWh+GUF3s5/CFkDVtfkmZ4JgT7
	GVKHQROAkdpwQgH/mbX0zjcaPdKpCeEU+lSfrTXZ5wxa2ofozHMrRK9THFiYZYtygaX7Ma8a6mnIZ
	zmcJr4CsJWiS7umUNA1bYo4RQ830IaTVE1xcmPSc5XHX44c1KUs2p4A6E/GcpEBW8DIlzzqBWsCMd
	vX57SjP0m63bp/8+9uw8ZwQzGqa/YMe5GXcKZ6mphGkpLohZ4vA80mIcUnRGrDKrHz4aEFiL0G8/R
	jeyk8Q8UmR5ulxbTM2CUNN9J8u0iB2JBIEmsXEM60WFfysKhCvJSzzJqh1dgDafNh15/jwd2Fr+Ku
	vf+IJGIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB3lU-0000000HLuk-0rJd;
	Mon, 28 Sep 2026 05:19:00 +0000
Date: Sun, 27 Sep 2026 22:19:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate
 offload
Message-ID: <arn4xOIxFRD8qY_x@infradead.org>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Sep 26, 2026 at 12:55:13PM +0800, Matthias Goergens wrote:
> This RFC adds offload-only swap areas for deliberate cold-page offload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.

Out of tree code not matter.  Out of tree that violates the linux
license terms even less.

Either way block devices must be safe to be called from paging paths,
not just for swap but also for file system based paging.  So this is a
bug in the implementation, and not something worked around in the swap
code.
