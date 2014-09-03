From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v3] memfd_test: Make it work on 32-bit systems
Date: Wed, 03 Sep 2014 15:41:54 -0600
Message-ID: <54078B22.5020200@osg.samsung.com>
References: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pranith Kumar <bobby.prani@gmail.com>, David Herrmann <dh.herrmann@gmail.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 09/03/2014 08:31 AM, Pranith Kumar wrote:
> This test currently fails on 32-bit systems since we use u64 type to pass the
> flags to fcntl.
> 
> This commit changes this to use 'unsigned int' type for flags to fcntl making it
> work on 32-bit systems.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> ---

I will queue this up for 3.17-fixes. I am in the process of
setting up kselftest git for fixes.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
