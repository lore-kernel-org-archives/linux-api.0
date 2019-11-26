From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 06/12] btrfs: remove dead snapshot-aware defrag
 code
Date: Tue, 26 Nov 2019 17:13:42 +0200
Message-ID: <1165c066-09ae-df4b-856d-df27c1c9aca3@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <a33a0fddb55101eec47b815672aa42b6f85b3830.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a33a0fddb55101eec47b815672aa42b6f85b3830.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Snapshot-aware defrag has been disabled since commit 8101c8dbf624
> ("Btrfs: disable snapshot aware defrag for now") almost 6 years ago.
> Let's remove the dead code. If someone is up to the task of bringing it
> back, they can dig it up from git.
> 
> This is logically a revert of commit 38c227d87c49 ("Btrfs:
> snapshot-aware defrag") except that now we have to clear the
> EXTENT_DEFRAG bit to avoid need_force_cow() returning true forever.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
