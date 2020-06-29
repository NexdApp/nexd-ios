//
//  NexdUI+RequestList.swift
//  nexd
//
//  Created by Tobias Schröpf on 02.06.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import NexdClient
import SwiftUI

extension HelpRequest {
    var icon: some View {
        if callSid == nil {
            return R.image.baseline_contact_mail_black_24pt.image
                .foregroundColor(R.color.requestListItemIcon.color)
        } else {
            return R.image.baseline_contact_phone_black_24pt.image
                .foregroundColor(R.color.requestListItemIcon.color)
        }
    }

    var detailsText: some View {
        let duration = createdAt?.difference()
        let type = callSid == nil ? R.string.localizable.helper_request_overview_item_type_list()
            : R.string.localizable.helper_request_overview_item_type_recording()
        let details = R.string.localizable.helper_request_overview_open_request_item_details_format_ios(duration ?? "???", type)
        return Text(details)
            .font(R.font.proximaNovaRegular.font(size: 14))
            .foregroundColor(R.color.requestListItemDetails.color)
    }

    var title: some View {
        return Text(displayName)
            .font(R.font.proximaNovaBold.font(size: 28))
            .foregroundColor(R.color.requestListItemTitle.color)
    }
}

extension NexdUI {
    struct RequestListItem: View {
        let item: HelpRequest
        let onTapped: () -> Void

        var body: some View {
            Button(action: onTapped) {
                HStack {
                    item.icon

                    VStack(alignment: .leading) {
                        item.detailsText

                        item.title
                    }
                    .padding([.leading, .trailing], 12)

                    Spacer()

                    R.image.chevron.image
                        .foregroundColor(R.color.requestListItemBorder.color)
                }
                .padding([.leading, .trailing], 18)
                .frame(height: 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.color.darkButtonBorder.color, lineWidth: 2)
                )
            }
            .padding([.leading, .trailing], 8)
        }
    }

    struct RequestList: View {
        let items: [HelpRequest]
        let onTapped: (HelpRequest) -> Void

        var body: some View {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    NexdUI.RequestListItem(item: item, onTapped: { self.onTapped(item) })
                }
            }
        }
    }
}
