From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] powerpc: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 4 Feb 2016 14:22:44 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1602041422330.29117@chino.kir.corp.google.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com> <1454565386-10489-5-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454565386-10489-5-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

On Thu, 4 Feb 2016, Joonsoo Kim wrote:

> We can disable debug_pagealloc processing even if the code is complied
> with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
> whether it is enabled or not in runtime.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
