From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [RFC PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Mon, 27 Nov 2017 08:51:10 -0700
Message-ID: <4f5eb24c-5af2-eebf-d54f-875f4b259793@oracle.com>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116121438.6vegs4wiahod3byl@dhcp22.suse.cz>
 <20171124085405.dwln5k3dk7fdio7e@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171124085405.dwln5k3dk7fdio7e@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 11/24/2017 01:54 AM, Michal Hocko wrote:
> Are there any more concerns? So far the biggest one was the name. The
> other which suggests a flag as a modifier has been sorted out hopefully.
> Is there anymore more before we can consider this for merging? Well
> except for man page update which I will prepare of course. Can we target
> this to 4.16?

I do not have concerns with this approach. I prefer a new flag as 
opposed to a modifier and the name is ok by me.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
