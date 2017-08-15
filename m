From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
Date: Tue, 15 Aug 2017 09:28:21 -0700
Message-ID: <CALCETrU811Ac+DpiUP8MdayA6cD3Jk+Dd0RXAqk5YM6Lj9YsDQ@mail.gmail.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 14, 2017 at 11:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The mmap syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> mechanism to define new behavior that is known to fail on older kernels
> without the feature. Use the fact that specifying MAP_SHARED and
> MAP_PRIVATE at the same time is invalid as a cute hack to allow a new
> set of validated flags to be introduced.

While this is cute, is it actually better than a new syscall?
