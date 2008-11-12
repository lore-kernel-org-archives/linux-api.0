From: Vivien Chappelier <vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org>
Subject: Re: [patch 1/2][RFC] add socketat syscall
Date: Wed, 12 Nov 2008 16:59:57 +0100
Message-ID: <491AFD7D.4080505@thomson.net>
References: <20081031215602.655672481@fr.ibm.com>	<20081031215900.810348746@fr.ibm.com>	<517f3f820811060522i7b3518aen47907a34b38adee9@mail.gmail.com>	<cfd18e0f0811060746l77fbe6fel83402ba543fccb38@mail.gmail.com>	<491318DC.4000300@fr.ibm.com> <49143263.1040604@fr.ibm.com>	<49143594.8030109@fr.ibm.com> <491AB112.1030806@thomson.net> <m1vdutotky.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m1vdutotky.fsf-B27657KtZYmhTnVgQlOflh2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, Cedric Le Goater <clg-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Subrata Modak <subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andreas B Aaen <andreas.aaen-546VmZ+UeKYX2WXlbB3fKg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

> I'm trying to get a feel.  What kind of applications do you have for which
> you are changing the default network namespace aka chvrf?
>   
    No problem to detail a bit more. We are working on products for 
telephony operators that generally need both a classical 'user' access 
to the internet and a priviledged 'services' access to the operator network.

    My first example is a cable modem (CM), IP phone (eMTA) and router. 
The DOCSIS and PacketCable standards require this product to have 
separate networks for each of these features, bridged together at the 
MAC level, so that it behaves exactly as three separate boxes from the 
operator's network point of view. So we have:
- default network namespace '0' for the router and standard Linux 
applications that need internet access.
- network namespace '1' for the CM
- network namespace '2' for the eMTA
- a bridge connecting the CM interface, eMTA interface and router 
WAN-side interface together
    Basically, the CM application is run in a chvrf context and performs 
its DHCP and TFTP requests on the operator network using the CM MAC 
address. The same way, the eMTA application is run in its own network 
for its DHCP, TFTP and all the VOIP related traffic (MGCP signaling and 
RTP voice traffic) using the eMTA MAC address. The CM network is also 
used for firmware upgrade.

    A second example is a product mixing an internet browser and a set 
top box-like access to the operator's TV network. In this case, the 
operator's network for internet and TV use separate VLANs and DHCP 
requests on each network may provide IP addresses in the same subnet. So 
in this case, one DHCP client and the TV player are run in chvrf context.

    I hope it clarifies our use case a bit more and why we need and use 
the VRF feature.

regards,
Vivien.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
