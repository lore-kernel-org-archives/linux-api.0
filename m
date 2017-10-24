From: Jordan Crouse <jcrouse@codeaurora.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 24 Oct 2017 10:14:44 -0600
Message-ID: <20171024161444.GA14939@jcrouse-lnx.qualcomm.com>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com, devel@driverdev.osuosl.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 05:55:37PM +0200, Benjamin Gaignard wrote:
> Instead a getting only one common device "/dev/ion" for
> all the heaps this patch allow to create one device
> entry ("/dev/ionX") per heap.
> Getting an entry per heap could allow to set security rules
> per heap and global ones for all heaps.
> 
> Allocation requests will be only allowed if the mask_id
> match with device minor.
> Query request could be done on any of the devices.
> 
> Ion devices are parentless so it is need to add platform_bus as
> parent and platform_bus_type as bus to be put in /sys/device/paltform.

nit: paltform -> platform.

Jordan

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
