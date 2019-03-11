From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCHv8 00/10] Heterogenous memory node attributes
Date: Tue, 12 Mar 2019 00:06:54 +0100
Message-ID: <1220029b-98eb-270e-2d11-30223ac25984@inria.fr>
References: <20190311205606.11228-1-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311205606.11228-1-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: linux-api@vger.kernel.org

Le 11/03/2019 à 21:55, Keith Busch a écrit :
> == Changes since v7 ==
>
>   Fixed an early return that prevented reporting HMAT when there are no
>   direct attached initiators.
>
>   Fixed introducing a variable that was unused until several patches
>   later.
>
>   Miscellaneous typos, editorial clarifications, and whitespace fixups.
>
>   Merged to most current linux-next.
>
>   Added received review, test, and ack by's.


Tested-by: Brice Goglin <Brice.Goglin@inria.fr>

I tested this series with several manually-created HMATs.

I already have user-space support in hwloc for reading initiator
symlinks and memory-side cache information.

Looks good.


Given the feedback I sent, patches 06 and 07 even deserve

Reviewed-by: Brice Goglin <Brice.Goglin@inria.fr>

Brice
