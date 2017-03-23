From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [net-next PATCH v2 1/8] net: Busy polling should ignore sender
 CPUs
Date: Thu, 23 Mar 2017 15:05:52 -0700
Message-ID: <1490306752.9687.7.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170323211820.12615.88907.stgit@localhost.localdomain>
         <20170323213637.12615.11197.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170323213637.12615.11197.stgit@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sridhar.samudrala@intel.com, edumazet@google.com, davem@davemloft.net, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2017-03-23 at 14:36 -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> This patch is a cleanup/fix for NAPI IDs following the changes that made it
> so that sender_cpu and napi_id were doing a better job of sharing the same
> location in the sk_buff.
> 
> One issue I found is that we weren't validating the napi_id as being valid
> before we started trying to setup the busy polling.  This change corrects
> that by using the MIN_NAPI_ID value that is now used in both allocating the
> NAPI IDs, as well as validating them.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>
