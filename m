Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E90C433DB
	for <linux-api@archiver.kernel.org>; Tue, 16 Mar 2021 00:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F4864F60
	for <linux-api@archiver.kernel.org>; Tue, 16 Mar 2021 00:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCPAf7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 15 Mar 2021 20:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhCPAfv (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 15 Mar 2021 20:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6DBF64EE2;
        Tue, 16 Mar 2021 00:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615854950;
        bh=OlgHNp9jm/EH6kf+3kGJKCQXgOVwBtcBmr5ej4m/h88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lpbG3tXBmVG0SK4DzL14WLha/peGHTAGXryO9fzxzvMlibA0YcaLCZj0Aehdo2nva
         tpQbqB9Zcns6CNX/l9qkHwntyoRpW9NuvCPjEvBRll2rTxU63YBJJhUkgPBCSjB28i
         qg2Nuvl3XHItGjvDVPM/ZbMsfoywoTLX6PPYaQyJOWWkD3IZkrUsFKr5uRTW6F94aH
         2gYtRm8MGmxBfBJBDl0a2eAI73humNHOK87EIcGuzsXhVyRpdG1GDrELypn7EKjv22
         qRn0o4/uJZS7O7qB5a5Q28KX1OpZBbg2wYfftC3mhU6EtERmuWzeWhuEJMeFAgCOxP
         UWKdGoVJYawlg==
Date:   Tue, 16 Mar 2021 08:35:46 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     balbi@kernel.org, gregkh@linuxfoundation.org,
        linux-api@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kurahul@cadence.com
Subject: Re: [PATCH v2 1/2] usb: gadget: uvc: Updating bcdUVC field to 0x0110
Message-ID: <20210316003545.GD15335@b29397-desktop>
References: <20210315065926.30152-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315065926.30152-1-pawell@gli-login.cadence.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 21-03-15 07:59:25, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Command Verifier during UVC Descriptor Tests (Class Video Control
> Interface Descriptor Test Video) complains about:
> 
> Video Control Interface Header bcdUVC is 0x0100. USB Video Class
> specification 1.0 has been replaced by 1.1 specification
> (UVC: 6.2.26) Class Video Control Interface Descriptor bcdUVC is not 1.1
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Reviewed-by: Peter Chen <peter.chen@kernel.org>

> 
> ---
> Changlog:
> v2:
> - fixed typo in commit message
> 
>  drivers/usb/gadget/function/uvc_configfs.c | 2 +-
>  drivers/usb/gadget/legacy/webcam.c         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
> index 00fb58e50a15..cd28dec837dd 100644
> --- a/drivers/usb/gadget/function/uvc_configfs.c
> +++ b/drivers/usb/gadget/function/uvc_configfs.c
> @@ -231,7 +231,7 @@ static struct config_item *uvcg_control_header_make(struct config_group *group,
>  	h->desc.bLength			= UVC_DT_HEADER_SIZE(1);
>  	h->desc.bDescriptorType		= USB_DT_CS_INTERFACE;
>  	h->desc.bDescriptorSubType	= UVC_VC_HEADER;
> -	h->desc.bcdUVC			= cpu_to_le16(0x0100);
> +	h->desc.bcdUVC			= cpu_to_le16(0x0110);
>  	h->desc.dwClockFrequency	= cpu_to_le32(48000000);
>  
>  	config_item_init_type_name(&h->item, name, &uvcg_control_header_type);
> diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
> index a9f8eb8e1c76..3a61de4bb2b1 100644
> --- a/drivers/usb/gadget/legacy/webcam.c
> +++ b/drivers/usb/gadget/legacy/webcam.c
> @@ -90,7 +90,7 @@ static const struct UVC_HEADER_DESCRIPTOR(1) uvc_control_header = {
>  	.bLength		= UVC_DT_HEADER_SIZE(1),
>  	.bDescriptorType	= USB_DT_CS_INTERFACE,
>  	.bDescriptorSubType	= UVC_VC_HEADER,
> -	.bcdUVC			= cpu_to_le16(0x0100),
> +	.bcdUVC			= cpu_to_le16(0x0110),
>  	.wTotalLength		= 0, /* dynamic */
>  	.dwClockFrequency	= cpu_to_le32(48000000),
>  	.bInCollection		= 0, /* dynamic */
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen

