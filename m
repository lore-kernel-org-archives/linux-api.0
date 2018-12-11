From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/3] THP eligibility reporting via proc
Date: Tue, 11 Dec 2018 15:36:38 +0100
Message-ID: <20181211143641.3503-1-mhocko@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Rientjes <rientjes@google.com>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

Hi,
I've posted this as an RFC [1] and there didn't seem to be any pushback
so I am posting it for inclusion. If there are any concerns, please
speak up.

Original cover:
This series of three patches aims at making THP eligibility reporting
much more robust and long term sustainable. The trigger for the change
is a regression report [2] and the long follow up discussion. In short
the specific application didn't have good API to query whether a particular
mapping can be backed by THP so it has used VMA flags to workaround that.
These flags represent a deep internal state of VMAs and as such they should
be used by userspace with a great deal of caution.

A similar has happened for [3] when users complained that VM_MIXEDMAP is
no longer set on DAX mappings. Again a lack of a proper API led to an
abuse.

The first patch in the series tries to emphasise that that the semantic
of flags might change and any application consuming those should be really
careful.

The remaining two patches provide a more suitable interface to address [2]
and provide a consistent API to query the THP status both for each VMA
and process wide as well.

[1] http://lkml.kernel.org/r/20181120103515.25280-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/http://lkml.kernel.org/r/alpine.DEB.2.21.1809241054050.224429@chino.kir.corp.google.com
[3] http://lkml.kernel.org/r/20181002100531.GC4135@quack2.suse.cz
