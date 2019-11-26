From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH v3 05/12] btrfs: don't advance offset for compressed
 bios in btrfs_csum_one_bio()
Date: Tue, 26 Nov 2019 09:50:15 -0800
Message-ID: <20191126175015.GA658856@vader>
References: <cover.1574273658.git.osandov@fb.com>
 <a669365a9165b18814c635f61ed566fdcd47a96f.1574273658.git.osandov@fb.com>
 <9669273e-5a73-540f-2091-5ce64e093062@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9669273e-5a73-540f-2091-5ce64e093062@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Tue, Nov 26, 2019 at 04:18:45PM +0200, Nikolay Borisov wrote:
> 
> 
> On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > btrfs_csum_one_bio() loops over each sector in the bio while keeping a
> 
> 'sector' here is ambiguous it really loops over every fs block (which in
> btrfs is also known as sector). SO perhaps change the wording in the
> changelog but also in the function instead of nr_sectors perhahps it
> could be renamed to blockcount?

Fixed, thanks.
