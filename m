From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Fri, 26 Apr 2019 11:08:44 -0700
Message-ID: <CACdnJutweLKsir_r9EgP9g=Eih-hbhq20N8zHzKawR8=awnENw@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com> <20190425121410.GC1144@dhcp22.suse.cz>
 <20190425123755.GX12751@dhcp22.suse.cz> <CACdnJuutwmBn_ASY1N1+ZK8g4MbpjTnUYbarR+CPhC5BAy0oZA@mail.gmail.com>
 <20190426052520.GB12337@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190426052520.GB12337@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 10:25 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 25-04-19 13:39:01, Matthew Garrett wrote:
> > Yes, given MADV_DONTDUMP doesn't imply mlock I thought it'd be more
> > consistent to keep those independent.
>
> Do we want to fail madvise call on VMAs that are not mlocked then? What
> if the munlock happens later after the madvise is called?

I'm not sure if it's strictly necessary. We already have various
combinations of features that only make sense when used together and
which can be undermined by later actions. I can see the appeal of
designing this in a way that makes it harder to misuse, but is that
worth additional implementation complexity?
