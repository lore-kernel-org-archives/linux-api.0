From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/3] ACPI / debugger: Add kernel flushing support
Date: Wed, 17 Aug 2016 02:25:27 +0200
Message-ID: <3495155.KjS3JCMr0I@vostro.rjw.lan>
References: <cover.1468464391.git.lv.zheng@intel.com> <cover.1469528979.git.lv.zheng@intel.com> <accaa346738c7e405e06dca2aa20088ffa94e3e7.1469528980.git.lv.zheng@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <accaa346738c7e405e06dca2aa20088ffa94e3e7.1469528980.git.lv.zheng@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday, July 26, 2016 07:01:33 PM Lv Zheng wrote:
> This patch adds debugger output flushing support in kernel via .ioctl()
> callback. The in-kernel flushing is more efficient, because it reduces
> useless log IOs by bypassing log user_read/kern_write during the flush
> period.
> 
> This mechanism is useful for the batch mode.

Is it only useful or is it required?

Also the batch mode is introduced by the remaining patches in the series,
isn't it?

> Scripts can integrate a batch mode acpidbg instance to perform AML debugger
> functionalities.

This sentence is not parsable for me.  What does it mean, really?

> As the batch mode always starts from a new command write, it thus requires
> the kernel debugger driver to drop the old input/output first.

What does "the old" mean here?

> The old input is automatically dropped by acpi_os_get_line() via an error
> returning value,

I can't parse this too, sorry.

> but the output are remained in acpi_dbg output buffers and should be
> dropped prior than reading the new command, otherwise, the old output can
> be read out by the batch mode instance and the result of the batch mode
> command will be messed up.

Can you give an example here for clarity, please?

Thanks,
Rafael

