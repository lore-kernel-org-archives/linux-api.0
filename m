From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 3/5] sound: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 4 Feb 2016 14:19:25 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1602041419130.29117@chino.kir.corp.google.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com> <1454565386-10489-4-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1454565386-10489-4-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
