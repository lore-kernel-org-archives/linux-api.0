From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] toshiba_acpi: Add /dev/toshiba_acpi device
Date: Thu, 16 Jul 2015 23:42:19 -0700
Message-ID: <20150717064219.GA128212@vmdeb7>
References: <1437089564-4242-1-git-send-email-coproscefalo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437089564-4242-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jonathan Buzzard <jonathan@buzzard.org.uk>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 16, 2015 at 05:32:44PM -0600, Azael Avalos wrote:
> There were previous attempts to "merge" the toshiba SMM module to the
> toshiba_acpi one, they were trying to imitate what the old toshiba
> module does, however, some models (TOS1900 devices) come with a
> "crippled" implementation and do not provide all the "features" a
> "genuine" Toshiba BIOS does.
> 
> This patch adds a new device called toshiba_acpi, which aim is to
> enable userspace to access the SMM on Toshiba laptops via ACPI calls.
> 
> Creating a new convenience _IOWR command to access the SCI functions
> by opening/closing the SCI internally to avoid buggy BIOS, while at
> the same time providing backwards compatibility.
> 
> Older programs who wish to access the SMM on newer models can do it
> without much code change, as the toshiba.h header was modified to
> reflect these changes as well as adds all the toshiba_acpi paths
> and commands.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

This and the other 2 are queued to for-review. They will remain there for a few
days to give others a chance to review. After that, I will provide a thorough
review and move them into for-next for 4.3

They do pass all my preliminary tests, checkpatch, build, and ninja-check.

As this is the first series that I've received since enabling a lot of new
automation, I wanted to say thanks for clean series that is ready review. Nice.

-- 
Darren Hart
Intel Open Source Technology Center
