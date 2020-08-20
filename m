Return-Path: <SRS0=qcTw=B6=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0A9C433E1
	for <linux-api@archiver.kernel.org>; Thu, 20 Aug 2020 22:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0474207DF
	for <linux-api@archiver.kernel.org>; Thu, 20 Aug 2020 22:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597962097;
	bh=YZFXjRScFns5Q/JX8kMKWW0SqdzIXgtS9wkbdlVq+aY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:List-ID:From;
	b=T4926zLegcgQ1chHIK1/3froR9PZPvNNWLGF9EMpQuFJ3WyQJjFrz3re9mGJe6crr
	 0OYKqVjaD3LUCzIgQhfFZ9esu0YU+39+AHTeDiK8yyH5rtAlPNmf+Hx0HHvFB6rSi0
	 RoY3EsUDRwlFPkFvflUXDa0bPpri7zF8PwJ+maa0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgHTWVh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 20 Aug 2020 18:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgHTWVb (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 20 Aug 2020 18:21:31 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C832075E;
        Thu, 20 Aug 2020 22:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597962091;
        bh=YZFXjRScFns5Q/JX8kMKWW0SqdzIXgtS9wkbdlVq+aY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=knEda3aCkNQRb87lx+sMgW3yN3C0Y6JlzUzcCgx8GpjQ10pVHNJ4crvidnJ1gmard
         5v3EkkglnDiXCky0Pjvo1GthcdGBaGo/AMvK4GnWaK1ckhnJ7Kws0ZkiAgZ0Z2+TtX
         yfwNjy/fqDviqP4iGN/YePrORscJex7NxAo+wTqo=
Date:   Thu, 20 Aug 2020 17:21:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rafael@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxarm@huawei.com,
        Dan Williams <dan.j.williams@intel.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Sean V Kelley <sean.v.kelley@linux.intel.com>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v9 4/6] ACPI: HMAT: Fix handling of changes from ACPI 6.2
 to ACPI 6.3
Message-ID: <20200820222129.GA1571389@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819145111.1715026-5-Jonathan.Cameron@huawei.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Aug 19, 2020 at 10:51:09PM +0800, Jonathan Cameron wrote:
> In ACPI 6.3, the Memory Proximity Domain Attributes Structure
> changed substantially.  One of those changes was that the flag
> for "Memory Proximity Domain field is valid" was deprecated.
> 
> This was because the field "Proximity Domain for the Memory"
> became a required field and hence having a validity flag makes
> no sense.
> 
> So the correct logic is to always assume the field is there.
> Current code assumes it never is.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  drivers/acpi/numa/hmat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 2c32cfb72370..07cfe50136e0 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -424,7 +424,7 @@ static int __init hmat_parse_proximity_domain(union acpi_subtable_headers *heade
>  		pr_info("HMAT: Memory Flags:%04x Processor Domain:%u Memory Domain:%u\n",
>  			p->flags, p->processor_PD, p->memory_PD);
>  
> -	if (p->flags & ACPI_HMAT_MEMORY_PD_VALID && hmat_revision == 1) {
> +	if ((p->flags & ACPI_HMAT_MEMORY_PD_VALID && hmat_revision == 1) || hmat_revision == 2) {

I hope/assume the spec is written in such a way that p->memory_PD is
required for any revision > 1?  So maybe this should be:

  if ((p->flags & ACPI_HMAT_MEMORY_PD_VALID && hmat_revision == 1) ||
      hmat_revision > 1) {

>  		target = find_mem_target(p->memory_PD);
>  		if (!target) {
>  			pr_debug("HMAT: Memory Domain missing from SRAT\n");
> -- 
> 2.19.1
> 
