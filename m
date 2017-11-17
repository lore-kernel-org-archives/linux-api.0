From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Fri, 17 Nov 2017 08:30:48 +0100
Message-ID: <a3f7aed9-0df2-2fd6-cebb-ba569ad66781@redhat.com>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116101900.13621-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171116101900.13621-2-mhocko@kernel.org>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On 11/16/2017 11:18 AM, Michal Hocko wrote:
> +	if (flags & MAP_FIXED_SAFE) {
> +		struct vm_area_struct *vma = find_vma(mm, addr);
> +
> +		if (vma && vma->vm_start <= addr)
> +			return -ENOMEM;
> +	}

Could you pick a different error code which cannot also be caused by a 
an unrelated, possibly temporary condition?  Maybe EBUSY or EEXIST?

This would definitely help with application-based randomization of 
mappings, and there, actual ENOMEM and this error would have to be 
handled differently.

Thanks,
Florian
