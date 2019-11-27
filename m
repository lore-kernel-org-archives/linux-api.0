From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 08/12] btrfs: add ram_bytes and offset to
 btrfs_ordered_extent
Date: Wed, 27 Nov 2019 12:13:32 +0200
Message-ID: <5f344a25-c537-5bf0-40a8-44b9130b4b3c@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <acc02c48287b503195a513e4210d6ddd9e89418a.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <acc02c48287b503195a513e4210d6ddd9e89418a.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we only create ordered extents when ram_bytes == num_bytes
> and offset == 0. However, RWF_ENCODED writes may create extents which
> only refer to a subset of the full unencoded extent, so we need to plumb
> these fields through the ordered extent infrastructure and pass them
> down to insert_reserved_file_extent().
> 
> Since we're changing the btrfs_add_ordered_extent* signature, let's get
> rid of the trivial wrappers and add a kernel-doc.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
