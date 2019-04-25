From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Thu, 25 Apr 2019 13:39:01 -0700
Message-ID: <CACdnJuutwmBn_ASY1N1+ZK8g4MbpjTnUYbarR+CPhC5BAy0oZA@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com> <20190425121410.GC1144@dhcp22.suse.cz>
 <20190425123755.GX12751@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425123755.GX12751@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 5:37 AM Michal Hocko <mhocko@kernel.org> wrote:
> Besides that you inherently assume that the user would do mlock because
> you do not try to wipe the swap content. Is this intentional?

Yes, given MADV_DONTDUMP doesn't imply mlock I thought it'd be more
consistent to keep those independent.

> Another question would be regarding the targeted user API. There are
> some attempts to make all the freed memory to be zeroed/poisoned. Are
> users who would like to use this feature also be interested in using
> system wide setting as well?

I think that depends on the performance overhead of a global setting,
but it's also influenced by the semantics around when the freeing
occurs, which is something I haven't nailed down yet. If the
expectation is that the page is freed whenever the process exits, even
if the page is in use somewhere else, then we'd still want this to be
separate to poisoning on final page free.
