From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 09/12] btrfs: support different disk extent size
 for delalloc
Date: Wed, 27 Nov 2019 12:33:21 +0200
Message-ID: <0df9fd0a-e0d1-c8c1-6e2c-d831a20478ce@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <bfa7cb307be92418aee1cec4e23f98bf32a171de.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bfa7cb307be92418aee1cec4e23f98bf32a171de.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we always reserve the same extent size in the file and extent
> size on disk for delalloc because the former is the worst case for the
> latter. For RWF_ENCODED writes, we know the exact size of the extent on
> disk, which may be less than or greater than (for bookends) the size in
> the file. Add a disk_num_bytes parameter to
> btrfs_delalloc_reserve_metadata() so that we can reserve the correct
> amount of csum bytes. Additionally, make
> btrfs_free_reserve_data_space_noquota() take a number of bytes instead
> of a range, as it refers to the extent size on disk, not in the file. No
> functional change.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
