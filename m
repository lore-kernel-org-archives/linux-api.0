From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v6 00/29] FPGA Device Feature List (DFL) Device Drivers
Date: Tue, 12 Jun 2018 12:33:42 -0500
Message-ID: <CANk1AXSPd10twvT0tXKBxb9Cc2bK_TrVdZ6gnLKkB_ujCcD8wQ@mail.gmail.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 5:10 AM, Wu Hao <hao.wu@intel.com> wrote:
> Hi All,
>
> Here is v6 patch-series adding drivers for FPGA DFL devices.

I pushed this patchset to a branch on my linux-fpga kernel.org git
repo for the robots to test.

Alan

>
> This patch series provides a common framework to support FPGA Device Feature
> List (DFL), and also feature dev drivers under this DFL framework to provide
> interfaces for userspace applications to configure, enumerate, open, and
> access FPGA accelerators on DFL based FPGA device and enables system level
> management functions such as FPGA partial reconfiguration, power management
> and virtualization.
