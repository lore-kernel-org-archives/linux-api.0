From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Fri, 26 Apr 2019 07:25:20 +0200
Message-ID: <20190426052520.GB12337@dhcp22.suse.cz>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com>
 <20190425121410.GC1144@dhcp22.suse.cz>
 <20190425123755.GX12751@dhcp22.suse.cz>
 <CACdnJuutwmBn_ASY1N1+ZK8g4MbpjTnUYbarR+CPhC5BAy0oZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuutwmBn_ASY1N1+ZK8g4MbpjTnUYbarR+CPhC5BAy0oZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 25-04-19 13:39:01, Matthew Garrett wrote:
> On Thu, Apr 25, 2019 at 5:37 AM Michal Hocko <mhocko@kernel.org> wrote:
> > Besides that you inherently assume that the user would do mlock because
> > you do not try to wipe the swap content. Is this intentional?
> 
> Yes, given MADV_DONTDUMP doesn't imply mlock I thought it'd be more
> consistent to keep those independent.

Do we want to fail madvise call on VMAs that are not mlocked then? What
if the munlock happens later after the madvise is called?

-- 
Michal Hocko
SUSE Labs
