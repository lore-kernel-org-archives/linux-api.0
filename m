From: William Kucharski <william.kucharski@oracle.com>
Subject: Re: [RFC PATCH 3/3] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Mon, 26 Nov 2018 17:33:32 -0700
Message-ID: <0ACDD94B-75AD-4DD0-B2E3-32C0EDFBAA5E@oracle.com>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-4-mhocko@kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120103515.25280-4-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org



This determines whether the page can theoretically be THP-mapped , but =
is the intention to also check for proper alignment and/or preexisting =
PAGESIZE page cache mappings for the address range?

I'm having to deal with both these issues in the text page THP prototype =
I've been working on for some time now.

    Thanks,
         William Kucharski=
